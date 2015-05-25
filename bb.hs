import System.Exit

-- based on RFC 2812: https://tools.ietf.org/html/rfc2812

-- RFC2812;2.3.1: TCP/IP most common underlying network protocol.

data Server = Server
    { hostname  :: String
    , port      :: String
    , tls       :: Bool
    }
  deriving (Show)

data Bot = Bot
    { nicks     :: [String]
    , username  :: String
    , realname  :: String
    , usermode  :: Integer
    , channels  :: [String]
    }


-- Default server variables, TODO put these into a config file and read them.
s = Server
    { hostname = "localhost"
    , port = "6667"
    , tls = False
    }

-- Default bot variables
b = Bot
    { nicks    = ["BottoB", "toB", "Bot12345"]
    , username = "bot"
    , realname = "bot"
    , usermode = 0
    , channels = ["#testset"]
    }

putHelpInformation :: IO ()
putHelpInformation = do
  putStrLn("Commands:")
  putStrLn("  c: connect")
  putStrLn("  d: disconnect")
  putStrLn("  h: help (this menu)")
  putStrLn("  q: quit")
  putStrLn("  s: show configuration") -- todo
  putStrLn("  r: reload default configuration") -- todo

main :: IO ()
main = do
  putStrLn ("Default configuration:")
  -- putDefaultConfig()
  putStrLn ("Please enter command (h for help): ")
  line <- getLine
  case line of
    "h"  -> putHelpInformation
    "q"  -> exitSuccess
    _    -> return () -- do nothing
  main
