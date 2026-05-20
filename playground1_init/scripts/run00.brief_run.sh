set -ue

#--------------------------#
# Experiment configuration #
#--------------------------#
exp_version="exp1"
model="gpt-5.4-nano-birthright"
api_index=1
data_root="/qfs/projects/oddite/peng599/Data/GenoTEX/input"


#--------------------#
# Run the experiment #
#--------------------#
log_file="playground1_init/output.exp1.gpt-5.4-nano-birthright.$(date +%Y-%m-%dT%H.%M.%S).log"
cd ..
set -x
python main.py \
    --version "${exp_version}" \
    --model "${model}" \
    --api "${api_index}" \
    --data-root "${data_root}" \
    2>&1 | tee "${log_file}"
set +x
