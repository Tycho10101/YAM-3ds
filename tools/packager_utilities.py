import shutil
from zipfile import ZipFile, ZIP_DEFLATED
from create_love_file import build_love_file
from urllib.request import urlretrieve
from utilities import Variables

class Packager:
    def download_zip_package(self, url, zip_path):
        Variables.path.build_temp.mkdir(parents=True, exist_ok=True)

        print(f"Downloading love-11.5-win64.zip")
        urlretrieve(url, zip_path)
        print("Download Complete, now extracting.")
        with ZipFile(zip_path, "r") as zip_ref:
            zip_ref.extractall(Variables.path.build_temp)

        zip_path.unlink()
        print("Extracted")

    def combine_files(self, changes, extracted_path, output_path):
        for change in changes:
            if change['final']:
                print(f"Combining {change["file"]} and {Variables.project_name}.love")
                
                with open(extracted_path / change["final"], 'wb') as outfile:
                    for fname in [extracted_path / change["file"], Variables.path.build / f"{Variables.project_name}.love"]:
                        with open(fname, 'rb') as infile:
                            shutil.copyfileobj(infile, outfile)

                print(f"Created {change["final"]}")

            (extracted_path / change["file"]).unlink()

        with ZipFile(output_path, mode="w", compression=ZIP_DEFLATED) as archive:
            for file_path in extracted_path.rglob("*"):
                if file_path.is_file():
                    archive.write(file_path, arcname=file_path.relative_to(extracted_path))

        print(f"Windows build packaged to \"{output_path.relative_to(Variables.path.project)}\" ({output_path})")

    def clear_temp_dir(self):
        shutil.rmtree(Variables.path.build_temp)

    def package(self, url, changes, zip_path, extracted_path, output_path):
        self.download_zip_package(url, zip_path)
        build_love_file()
        self.combine_files(changes, extracted_path, output_path)
        self.clear_temp_dir()