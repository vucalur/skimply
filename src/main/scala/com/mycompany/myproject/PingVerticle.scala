package com.mycompany.myproject

import org.vertx.scala.core.eventbus.Message
import org.vertx.scala.platform.Verticle

class PingVerticle extends Verticle {

  override def start() {
    vertx.eventBus.registerHandler("ping", { msg: Message[String] =>
      msg.reply("pong")
    })
  }
}