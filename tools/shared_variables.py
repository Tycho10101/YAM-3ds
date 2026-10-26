from pathlib import Path

class Variables:
    project_name = "YAM-3ds"
    class path:
        project = Path(__file__).resolve().parent.parent # Gets YAM 3ds project root directory
        game = project / "game"
        build = project / "build"