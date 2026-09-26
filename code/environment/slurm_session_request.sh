#!/bin/bash
# Requests an interactive compute session on MeluXina.
# Module system and container runtime (Apptainer) are only available on
# compute nodes, not login nodes - all pipeline execution must happen here.
#
# 16 cores / 64GB was the final working allocation; an earlier 8-core/32GB
# request under-provisioned CPU relative to nf-core/rnaseq's TrimGalore step
# (see docs/technical_challenges_log.md).

srun --account=p201238 \
     --partition=cpu \
     --qos=default \
     --cpus-per-task=16 \
     --mem=64G \
     --time=06:00:00 \
     --pty bash
