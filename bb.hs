import Control.Exception
import Control.Monad (liftM, guard)
import Network.BSD
import Network.Socket
import System.Exit
import System.IO.Error

-- based on RFC 2812: https://tools.ietf.org/html/rfc2812

-- RFC2812;2.3.1: TCP/IP most common underlying network protocol.
-- This is an ipv4 bot I guess...

data Server = Server
    { hostname  :: HostName
    , port      :: PortNumber
    , tls       :: Bool
    , nicks     :: [String]
    , username  :: String
    , realname  :: String
    , usermode  :: Integer
    , channels  :: [String]
    }
  deriving (Show)

-- Default server variables, TODO put these into a config file and read them.
s = Server
    { hostname = "localhost" :: HostName
    , port = 6667
    , tls = False
    , nicks    = ["BottoB", "toB", "Bot12345"]
    , username = "bot"
    , realname = "bot"
    , usermode = 0
    , channels = ["#testset"]
    }



-- True if success
connectToServer :: Server -> IO ()
connectToServer ser = do
  sock <- socket AF_INET Stream defaultProtocol
  r <- tryJust (guard . isDoesNotExistError) $
                      liftM hostAddress . getHostByName $ hostname ser
  case r of
    Left e -> putStrLn ("Could not resolve the host: " ++ hostname ser)
    Right val -> connectSocket $ SockAddrInet (port ser) val
        where
          connectSocket = connect sock -- TODO handle failed connection

  putStrLn ("Connecting...") -- Ya okay...

                   
putHelpInformation :: IO ()
putHelpInformation = do
  putStrLn("Commands:")
  putStrLn("  c: connect")
--  putStrLn("  d: disconnect")
  putStrLn("  h: help (this menu)")
  putStrLn("  q: quit")
--  putStrLn("  s: show configuration")
--  putStrLn("  r: reload default configuration")

{-| This application is a simple IRC bot.
    It currently does not do anything.
    The program is intended to run on a server in a terminal multiplexer such
    as screen or tmux.
-}

{- Needed features:
     *Read configurations from a config file.
     *The commented out functions in the main() case of.
     *Some sort of testing integration.
     *fork to handle irc commands after connected to server?
     *ncurses view of IRC output?
-}

main :: IO ()
main = do
  putStrLn ("Please enter command (h for help): ")
  line <- getLine
  case line of
    "c"  -> connectToServer s
--    "d"  -> disconnectFromServer
    "h"  -> putHelpInformation
    "q"  -> exitSuccess
--    "r"  -> reloadConfiguration
--    "s"  -> putDefaultConfiguration
    _    -> return ()
  main
