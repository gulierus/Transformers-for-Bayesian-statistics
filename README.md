# Transformers for Bayesian statistics

The computation of posterior distributions lies at the heart of Bayesian
inference, and a number of methods exist for it, such as Markov chain Monte
Carlo. These methods, however, tend to be computationally expensive and
impractical for more complex tasks. The relatively new Prior-Data Fitted
Networks (PFN) architecture sidesteps this problem in a simple way: a
transformer trained on synthetic data sampled from the prior returns the entire
posterior predictive distribution in a single forward pass. Moreover, the method
is backed by results from mathematical statistics. The aim of this work is to
describe the architecture in detail, replicate its results on Gaussian process
regression, and empirically verify the theoretical hypotheses about its
behaviour. In our experiments, we measure how good the approximation of the
exact posterior is. We also study how the transformer layers redistribute the
work among themselves and how robust the method is under a misspecified prior.
Finally, we transfer the method to image segmentation and verify that its good
properties carry over there as well.

**Key words:** amortized inference, Bayesian inference, Gaussian processes, image
segmentation, Prior-Data Fitted Networks, transformer.

This repository holds the experiment notebooks and the tooling needed to
reproduce them. It accompanies a bachelor thesis on how PFN transformers
approximate Gaussian process inference.

## Repository layout

```
notebooks/                 experiment notebooks (English), one per experiment
download_models.py         fetch the pretrained checkpoints from Google Drive
models_manifest.json       list of checkpoints (size, sha256, Drive id) per notebook
MODELS.md                  how the model download and hosting work
stage_models_for_upload.py maintainer tool used to prepare the Drive upload
requirements.txt           Python dependencies
setup.sh                   installs the dependencies and the PFNs library
models/                    checkpoints land here after download (git-ignored)
```

## Installation

```bash
git clone https://github.com/gulierus/Transformers-for-Bayesian-statistics.git
cd Transformers-for-Bayesian-statistics
bash setup.sh
```

`setup.sh` installs the Python dependencies from `requirements.txt` and clones
and installs the [PFNs](https://github.com/automl/PFNs) library, which the
notebooks import. The code runs on CUDA, Apple Silicon (MPS) or CPU; the device
is selected automatically.

The segmentation notebooks additionally need UniverSeg:

```bash
pip install git+https://github.com/JJGO/UniverSeg.git
pip install scipy nibabel
```

## Downloading the models

The pretrained checkpoints are about 2.2 GB in total and are hosted on Google
Drive rather than in git. They are fetched on demand with `gdown` (installed by
`setup.sh`).

Each notebook downloads exactly the checkpoints it needs from its second cell:

```python
from download_models import ensure_models
ensure_models("Experiment_1_from_GP2")
```

You can also fetch them from the command line:

```bash
python download_models.py --list                       # show files and status
python download_models.py --notebook Experiment_2_from_GP2
python download_models.py --all                        # everything (about 2.2 GB)
```

Files already present with the correct size are skipped, and every download is
verified against the size and sha256 recorded in `models_manifest.json`. See
`MODELS.md` for details.

## Running the experiments

1. Complete the installation above.
2. Start Jupyter and open the `notebooks/` folder:

   ```bash
   jupyter notebook
   ```

3. Open a notebook and run the cells top to bottom. The first cell sets up the
   environment and locates the repository root; the second cell downloads the
   checkpoints for that notebook.

The notebooks read the working directory by walking up to the repository root,
so they run correctly regardless of where Jupyter was launched.

## Notebooks

| Notebook | Topic |
|---|---|
| `Experiments_from_GP1_big_model` | Fixed-hyperparameter model: attention structure, PFN vs Nadaraya-Watson vs the exact GP |
| `Experiments_from_GP1_random_model` | Random-hyperparameter model: convergence to the prior and variance calibration |
| `Experiment_1_from_GP2` | Label mixing vs kernel computation per layer |
| `Experiment_2_from_GP2` | Depth vs the Neumann-series view of the posterior solve |
| `Experiment_3_from_GP2` | Attention structure across layers |
| `Experiment_4_from_GP2` | Predictive distribution and hyperparameter uncertainty |
| `Experiment_5_from_GP2` | Post-hoc localization of the context |
| `Experiment_6_from_GP2` | Hyperparameter identification from the context |
| `Experiment_7_from_GP2` | Robustness under a misspecified prior |
| `Experiment_A_UniverSeg_segmentation` | Frozen UniverSeg as a segmentation diagnostic |
| `Experiment_C_PFN_segmentation` | A PFN for 2D segmentation vs the exact posterior |

Some notebooks were not run for the thesis and are included for completeness;
those without stored outputs can be executed with the steps above.

## Thesis

The full text of the thesis is available as [`thesis/thesis.pdf`](thesis/thesis.pdf).
This public version omits the official signed assignment and the signed
declaration of authorship pages; the academic content is unchanged.

## License

The source code and notebooks in this repository are released under the MIT
License (see `LICENSE`). The thesis text (`thesis/thesis.pdf`) is released under
the Creative Commons Attribution 4.0 International License (CC BY 4.0, see
`thesis/LICENSE`).
