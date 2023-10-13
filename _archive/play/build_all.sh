set -ex

for name in "1_base0" "2_rustbuilder" "3_rustbuilder" "4_base" "5_gobuilder" "6_vbuilder" "7_nsc" "8_natstools" "9_3bot" "10_nodejsbuilder"
do
    echo "START BUILDING $name"
    pushd $name
    bash build.sh
    popd
    echo "Welcome $i times"
done

