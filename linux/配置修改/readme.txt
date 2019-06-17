该脚本初步解决了配置的统一更改

传入两个参数，它会和jenkins的workspace进行拼接 例如你这个编译打包在pipeline-zsaGov-cicd/zsaGov下面
那它会在这个下面找排除编译产物目录的某个配置（已经写死）

然后找到具体行，整行替换

使用方法

./configure_sed pipeline-zsaGov-cicd/zsaGov 9305
到某目录下找，替换成9305端口