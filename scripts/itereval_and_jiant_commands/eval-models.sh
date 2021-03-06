TASK_NAME=$1
LR=$2
TRAIN_BATCH=$3
MODEL_TYPE=$4

SCRIPT_DIR=$PWD
cd ..
cd ..
BASE_DIR=$PWD

MODELS_DIR=${BASE_DIR}/models
DATA_DIR=${BASE_DIR}/tasks
CACHE_DIR=${BASE_DIR}/cache
RUN_CONFIG_DIR=${BASE_DIR}/run_configs

export PYTHONPATH=${BASE_DIR}/jiant:$PYTHONPATH

EVAL_BATCH_MULT=2

echo LR: $LR, BATCH: $TRAIN_BATCH

OUTPUT_DIR=${BASE_DIR}/experiments/iterative_evals/${TASK_NAME}
MODEL_PATH=${BASE_DIR}/experiments/${TASK_NAME}/${LR}_${TRAIN_BATCH}/best_model.p
RUN_CONFIG=${RUN_CONFIG_DIR}/${MODEL_TYPE}/eval_${TASK_NAME}_${LR}_${TRAIN_BATCH}.json

# Generate run configs
python jiant/jiant/proj/main/scripts/configurator.py \
    SingleTaskConfigurator ${RUN_CONFIG} \
    --task_name mnli \
    --train_batch_size ${TRAIN_BATCH} \
    --task_config_path ${DATA_DIR}/configs/eval_${TASK_NAME}_config.json \
    --task_cache_path ${CACHE_DIR}/${MODEL_TYPE}/eval_${TASK_NAME} \
    --eval_batch_multiplier ${EVAL_BATCH_MULT} \
    --do_val

sbatch --export=MODEL_PATH=$MODEL_PATH,MODELS_DIR=$MODELS_DIR,RUN_CONFIG=$RUN_CONFIG,OUTPUT_DIR=$OUTPUT_DIR,TASK_NAME=$TASK_NAME,MODEL_TYPE=$MODEL_TYPE ${SCRIPT_DIR}/litl_eval.sbatch
