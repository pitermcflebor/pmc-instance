fx_version 'cerulean'
game 'gta5'

description 'Instance wrapper made by PiterMcFlebor'
version '1.0'

server_only 'yes'

debug_log 'yes' -- set this to 'no' to disable output log messages
debug_message '[INSTANCE]: Player %s entered instance %s'

server_scripts {
    'server/misc.lua'
}
