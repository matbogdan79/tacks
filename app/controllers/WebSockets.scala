package controllers

import scala.concurrent.duration._
import akka.util.Timeout
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor.ActorRef
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import play.api.libs.json.{JsString, JsValue, Json, Format}
import play.api.mvc.{Controller, WebSocket}
import play.api.mvc.WebSocket.FrameFormatter
import play.api.Play.current
import reactivemongo.bson.BSONObjectID

import models._
import models.JsonFormats._
import tools.JsonFormats.idFormat
import actors._
import dao._

object WebSockets extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  implicit val playerInputFrameFormatter = FrameFormatter.jsonFrame[PlayerInput]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def trackPlayer(trackId: String) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
      track <- TrackDAO.findById(trackId)
      ref <- (RacesSupervisor.actorRef ? GetTrackActorRef(track)).mapTo[ActorRef]
    }
    yield Right(PlayerActor.props(ref, player)(_))
  }

  implicit val notifEventFormat: Format[NotificationEvent] = Json.format[NotificationEvent]
  implicit val notifEventFrameFormatter = FrameFormatter.jsonFrame[NotificationEvent]

  def notifications = WebSocket.tryAcceptWithActor[JsValue, NotificationEvent] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
    }
    yield Right(NotifiableActor.props(player)(_))
  }


  import Chat.actionFormat
  implicit val chatActionFrameFormatter = FrameFormatter.jsonFrame[Chat.Action]

  def chatRoom = WebSocket.tryAcceptWithActor[Chat.Action, Chat.Action] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
    }
    yield Right(ChatPlayerActor.props(player)(_))
  }

}