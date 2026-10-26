from zipfile import ZipFile, ZIP_DEFLATED
from pathlib import Path
from shared_variables import Variables

def build_love_file():
    output_path = Variables.path.build / f"{Variables.project_name}.love"

    Variables.path.build.mkdir(parents=True, exist_ok=True)
    output_path.unlink(missing_ok=True)

    with ZipFile(output_path, mode="w", compression=ZIP_DEFLATED) as archive:
        for file_path in Variables.path.game.rglob("*"):
            if file_path.is_file():
                archive.write(file_path, arcname=file_path.relative_to(Variables.path.game))

    print(f"Game packaged to \"{output_path.relative_to(Variables.path.project)}\" ({output_path})")

if __name__ == "__main__":
    build_love_file()
