import libtmux as tmuxp

server = tmuxp.Server()
# Create a new session
session = server.new_session(session_name="taiga", attach=False)

# Create new window and start taiga back
window = session.new_window(
    window_name="back",
    attach=False,
    start_directory="/taiga/taiga-back",
    window_shell="taiga/bin/gunicorn --workers 4 --timeout 60 -b 127.0.0.1:8001 taiga.wsgi",
)

# Create new window and start taiga events
window2 = session.new_window(
    window_name="events",
    attach=False,
    start_directory="/taiga/taiga-events",
    window_shell='/bin/bash -c "node_modules/coffeescript/bin/coffee index.coffee"',
)
