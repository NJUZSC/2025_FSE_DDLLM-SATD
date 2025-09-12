#!/bin/bash
#"apache-ant-1.7.0"
#"apache-jmeter-2.10"
    #"argouml"
   # "columba-1.4-src"
   #"jEdit-4.2"
    #"jfreechart-1.0.19"
   # "jruby-1.4.0"
   
    #"emf-2.4.1"
    #"hibernate-distribution-3.3.2.GA"
# 定义项目列表
PROJECTS=(
    "jruby-1.4.0"
)

ACCUMULATION_STEPS=8        
USE_LORA="lora"             
MODEL="Qwen2.5-3B-Instruct"

for EXP_NAME in "${PROJECTS[@]}"; do
    echo "============================================"
    echo "=== Processing project: $EXP_NAME ==="
    echo "============================================"

    # do
    echo "=== Running finetuning script ==="
    python SATD_special_token_finetune.py \
        --exp_name "$EXP_NAME" \
        --accumulation_steps "$ACCUMULATION_STEPS" \
        --use_lora "$USE_LORA" \
        --model "$MODEL"

    # 检查上一步是否成功
    if [ $? -ne 0 ]; then
        echo "Finetuning for $EXP_NAME failed! Skipping to next project."
        continue  
    fi

   
    echo "=== Running evaluation scripts ==="
    python /home/zsc/SATD_code/special_token_eval.py \
        --exp_name "$EXP_NAME" \
        --epochs 10 \
        --use_lora "$USE_LORA" \
        --model "$MODEL"

    
    if [ $? -ne 0 ]; then
        echo "Evaluation for $EXP_NAME failed!"
    fi
done

echo "All projects and tasks completed."