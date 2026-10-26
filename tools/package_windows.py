from create_love_file import build_love_file
from urllib.request import urlretrieve
from shared_variables import Variables
import shutil
from zipfile import ZipFile, ZIP_DEFLATED

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

def download_zip_package():
    Variables.path.build_temp.mkdir(parents=True, exist_ok=True)

    print(f"Downloading love-11.5-win64.zip")
    urlretrieve(URL, ZIP_PATH)
    print("Download Complete, now extracting.")
    with ZipFile(ZIP_PATH, "r") as zip_ref:
        zip_ref.extractall(Variables.path.build_temp)

    ZIP_PATH.unlink()
    print("Extracted")

def combine_files():
    for change in CHANGES:
        if change['final']:
            print(f"Combining {change["file"]} and {Variables.project_name}.love")
            
            with open(EXTRACTED_PATH / change["final"], 'wb') as outfile:
                for fname in [EXTRACTED_PATH / change["file"], Variables.path.build / f"{Variables.project_name}.love"]:
                    with open(fname, 'rb') as infile:
                        shutil.copyfileobj(infile, outfile)

            print(f"Created {change["final"]}")

        (EXTRACTED_PATH / change["file"]).unlink()

    with ZipFile(OUTPUT_PATH, mode="w", compression=ZIP_DEFLATED) as archive:
        for file_path in EXTRACTED_PATH.rglob("*"):
            if file_path.is_file():
                archive.write(file_path, arcname=file_path.relative_to(EXTRACTED_PATH))

    print(f"Windows build packaged to \"{OUTPUT_PATH.relative_to(Variables.path.project)}\" ({OUTPUT_PATH})")

def clear_temp_dir():
    shutil.rmtree(Variables.path.build_temp)

if __name__ == "__main__":
    download_zip_package()
    build_love_file()
    combine_files()
    clear_temp_dir()
