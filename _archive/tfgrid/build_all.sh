set -ex

source versions.sh

for name in "1_tfchain" "2_tfchain_graphql" "3_tfchain_activation_service" "4_gridproxy" "5_dashboard" "6_weblets" "7_zflist" "8_zdb" "9_zhub" "10_zinitramfs"
do
    echo "START BUILDING $name"
    pushd $name
    bash build.sh
    popd
done


echo "*** BUILD OF ALL DOCKERS WORKED FOR TFGRID***"