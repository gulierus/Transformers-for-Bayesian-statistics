# Model checkpoints

The pretrained PFN checkpoints are not stored in git. The essential set is about
2.2 GB across 28 files, several of them larger than GitHub's 100 MB per-file
limit. They are hosted on Google Drive and downloaded on demand into `models/`
with [gdown](https://github.com/wkentaro/gdown).

Everything is driven by [`models_manifest.json`](models_manifest.json): it lists
every checkpoint (relative path under `models/`, size, sha256, Google Drive id)
and which checkpoints each notebook needs.

## Downloading the models

1. Install the downloader dependency (also done by `setup.sh`):

   ```bash
   pip install gdown
   ```

2. Fetch the checkpoints. Either let each notebook pull what it needs (the second
   cell of every experiment notebook does this automatically):

   ```python
   from download_models import ensure_models
   ensure_models("Experiment_1_from_GP2")   # only this notebook's checkpoints
   ```

   or fetch from the command line:

   ```bash
   python download_models.py --list                       # show files and status
   python download_models.py --notebook Experiment_2_from_GP2
   python download_models.py --all                        # everything (about 2.2 GB)
   ```

Files already present with the correct size are skipped, so re-running is cheap.
Downloads are verified against the size and sha256 in the manifest.

## For the maintainer: updating the models

1. Stage the checkpoints into one flat folder (uses hard links, no extra disk):

   ```bash
   python stage_models_for_upload.py        # produces models_upload/
   ```

   Basenames are unique across the set, so a flat folder is unambiguous; the
   downloader restores subdirectories (for example `pfn_fixed_easy/`) from the
   manifest.

2. Upload the contents of `models_upload/` to a Google Drive folder and set it to
   "Anyone with the link, Viewer".

3. Point the manifest at the upload. Either set the top-level `gdrive_folder_id`
   to the folder id from its URL, or fill a `gdrive_id` for each file. Both are
   supported; per-file ids are the most robust.

## What is distributed

Only the checkpoints the notebooks load (28 files, about 2.2 GB). Older backups
and duplicate training runs are not distributed. Run
`python download_models.py --list` for the exact list and the per-notebook
breakdown.
