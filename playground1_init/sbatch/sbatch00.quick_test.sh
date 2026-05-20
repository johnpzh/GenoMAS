#!/bin/bash
#SBATCH --job-name="quick_test_gpt-5.4-nano-project"
#SBATCH --partition=slurm
######SBATCH --partition=dlv
######SBATCH --exclude=dc[119,077]
#SBATCH --account=oddite
#SBATCH -N 1
#SBATCH --time=10:00:00
#SBATCH --output=output.%x.%j.out.log
#SBATCH --error=output.%x.%j.err.log
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=zhen.peng@pnnl.gov
#SBATCH --exclusive

#### sinfo -p <partition>
#### sinfo -N -r -l
#### srun -A CENATE -N 1 -t 20:20:20 --pty -u /bin/bash

#First make sure the module commands are available.
source /etc/profile.d/modules.sh

#Set up your environment you wish to run in with module commands.
echo
echo "loaded modules"
echo
module purge
module load uv cuda
module list &> _modules.lis_
cat _modules.lis_
/bin/rm -f _modules.lis_

#Python version
# source /share/apps/python/miniconda25.5.1/etc/profile.d/conda.sh
# eval "$(conda shell.bash hook)"
# conda activate pp
source ../.venv/bin/activate
echo
echo "python version"
echo
command -v python
python --version
export PYTHON_PATH=$(command -v python)


#Next unlimit system resources, and set any other environment variables you need.
ulimit -s unlimited
echo
echo limits
echo
ulimit -a

#Is extremely useful to record the modules you have loaded, your limit settings,
#your current environment variables and the dynamically load libraries that your executable
#is linked against in your job output file.
# echo
# echo "loaded modules"
# echo
# module list &> _modules.lis_
# cat _modules.lis_
# /bin/rm -f _modules.lis_
# echo
# echo limits
# echo
# ulimit -a
echo
echo "Environment Variables"
echo
printenv
# echo
# echo "ldd output"
# echo
# ldd your_executable

#Now you can put in your parallel launch command.
#For each different parallel executable you launch we recommend
#adding a corresponding ldd command to verify that the environment
#that is loaded corresponds to the environment the executable was built in.

set -euo pipefail

export PREV_PWD=$(readlink -f .)

#--------------------------#
# Experiment configuration #
#--------------------------#
exp_version="test_preprocess"
# model="gpt-5.4-nano-birthright"
model="gpt-5.4-nano-project"
api_index=1
data_root="/qfs/projects/oddite/peng599/Data/GenoTEX/input"

#--------------------#
# Run the experiment #
#--------------------#
# log_file="playground1_init/output.exp1.gpt-5.4-nano-project.$(date +%Y-%m-%dT%H.%M.%S).log"

TOTAL_TIME_START=$(date +%s.%N)

cd .. # go to the project root
set -x
python main.py \
    --version "${exp_version}" \
    --model "${model}" \
    --api "${api_index}" \
    --data-root "${data_root}" \
    --quick-test
set +x

TOTAL_TIME_END=$(date +%s.%N)
TOTAL_TIME_DIFF=$(echo "${TOTAL_TIME_END} - ${TOTAL_TIME_START}" | bc -l)
echo "Total time: ${TOTAL_TIME_DIFF} seconds"