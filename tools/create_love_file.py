from zipfile import ZipFile, ZIP_DEFLATED
from pathlib import Path

GAME_NAME = "YAM-3ds"

def build_love_file():
    project_path = Path(__file__).resolve().parent.parent # Gets YAM 3ds project root directory
    game_path = project_path / "game"
    build_path = project_path / "build"
    output_path = build_path / f"{GAME_NAME}.love"

    build_path.mkdir(parents=True, exist_ok=True)
    output_path.unlink(missing_ok=True)

    with ZipFile(output_path, mode="w", compression=ZIP_DEFLATED) as archive:
        for file_path in game_path.rglob("*"):
            if file_path.is_file():
                archive.write(file_path, arcname=file_path.relative_to(game_path))

    print(f"Game packaged to \"{output_path.relative_to(project_path)}\" ({output_path})")

if __name__ == "__main__":
    build_love_file()
