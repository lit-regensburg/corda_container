from irods.session import iRODSSession
from pathlib import Path
from os import path
from enum import Enum
import argparse
import json

class Action(Enum):
    GET = "GET"
    PUT = "PUT"

parser = argparse.ArgumentParser()
# parser.add_argument("-d", "--descriptor", type=Path, required=True)
# parser.add_argument("-u", "--user", type=str, required=True)
# parser.add_argument("-p", "--password", type=str, required=True)
# parser.add_argument("-a", "--action", type=Action, required=True)
# parser.add_argument("-z", "--zone", type=str, required=True)
parser.add_argument("-e", "--env_file", type=Path)

args = parser.parse_args()


