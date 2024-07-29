import copernicusmarine
import os

copernicusmarine.login()

def download_dataset(cms_dir):
    # Ensure the cms_dir folder exists
    os.makedirs(cms_dir, exist_ok=True)

    # Set the current working directory to the cms_dir folder
    os.chdir(cms_dir)

    # Perform the download
    copernicusmarine.subset(
        dataset_id="dataset-carbon-rep-monthly",
        dataset_version="202311",
        variables=["omega_ar"],
        minimum_longitude=-179.875,
        maximum_longitude=179.875,
        minimum_latitude=-88.125,
        maximum_latitude=89.875,
        start_datetime="2012-01-01T00:00:00",
        end_datetime="2022-12-01T00:00:00",
        force_download=True,
        subset_method="strict",
        disable_progress_bar=True,
    )

    print(f"Download completed. Files saved in {cms_dir}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        cms_dir = sys.argv[1]
        download_dataset(cms_dir)
    else:
        print("Please provide an cms_dir folder path as an argument.")
