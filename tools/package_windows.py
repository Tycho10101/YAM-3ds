from utilities import Variables
from packager_utilities import Packager

URL = "https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip"
CHANGES = [
    {"file": "love.exe", "final": f"{Variables.project_name}.exe"}, 
    {"file": "lovec.exe", "final": f"{Variables.project_name}c.exe"},
    {"file": "readme.txt", "final": None},
    {"file": "changes.txt", "final": None}
]

ZIP_PATH = Variables.path.build_temp / f"love-11.5-win64.zip"
EXTRACTED_PATH = Variables.path.build_temp / "love-11.5-win64"
OUTPUT_PATH = Variables.path.build / f"{Variables.project_name}-win64.zip"

def package_windows():
    Packager().package(URL, CHANGES, ZIP_PATH, EXTRACTED_PATH, OUTPUT_PATH)

if __name__ == "__main__":
    package_windows()