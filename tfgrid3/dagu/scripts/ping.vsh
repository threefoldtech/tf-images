#!/usr/bin/env v

import encoding.base64
import freeflowuniverse.crystallib.clients.mycelium { get_msg_status, receive_msg, reply_msg, send_msg }

payload := 'im alive'
pk := os.getenv('HOME_PK')

println('sending im alive message')
msg := send_msg(pk, base64.encode_str(payload), false)!
println('message sent id: ${msg.id}')