PLATFORM_HOME="$(pwd)/hybris/bin/platform"
export PLATFORM_HOME

export ANT_OPTS="-Xmx200m -XX:MaxPermSize=128M"
echo Setting ant opts to: $ANT_OPTS

export ANT_HOME="$(pwd)/build/lib/apache-ant-1.9.1"
echo Setting ant home to: $ANT_HOME

chmod +x "$ANT_HOME/bin/ant"

export PATH="$ANT_HOME/bin:$PATH"
ant -version
