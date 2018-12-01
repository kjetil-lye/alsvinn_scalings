#!/bin/bash
set -e
for r i n64 128 256 512 1024 2048 4096;
do
    mkdir kelvinhelmholtz_${r};
    cp -r template_kelvinhelmholtz kelvinhelmholtz_${r}/kelvinhelmholtz;
    cp submit.sh kelvinhelmholtz_${r}/submit.sh
    sed -i "s/NX/${r}/g" kelvinhelmholtz_${r}/kelvinhelmholtz/kelvinhelmholtz.xml;
done

    
