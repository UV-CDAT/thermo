#!/usr/bin/env bash
PKG_NAME=thermo
USER=cdat
VERSION="8.0"
ESMF_CHANNEL="nesii/label/dev-esmf"
echo "Trying to upload conda"

if [ `uname` == "Linux" ]; then
    OS=linux-64
    echo "Linux OS"
    export PATH="$HOME/miniconda2/bin:$PATH"
    conda update -y -q conda
else
    echo "Mac OS"
    OS=osx-64
fi

mkdir ~/conda-bld
source activate root
conda config --set anaconda_upload no
export CONDA_BLD_PATH=${HOME}/conda-bld
echo "Cloning recipes"
git clone git://github.com/UV-CDAT/conda-recipes
cd conda-recipes

python ./prep_for_build.py
conda build $PKG_NAME -c cdat/label/nightly -c conda-forge -c cdat 
conda build $PKG_NAME -c cdat/label/nightly -c ${ESMF_CHANNEL} -c conda-forge -c cdat --python=3.6
anaconda -t $CONDA_UPLOAD_TOKEN upload -u $USER -l nightly $CONDA_BLD_PATH/$OS/$PKG_NAME-$VERSION.`date +%Y*`0.tar.bz2 --force
