#!/bin/bash

#Makes Pline zipball bundles for the downloads page
#1. Prepare source files
srcdir=~/Desktop/Pline
wrkdir=~/Downloads
[[ -d $srcdir && -d $wrkdir ]] || { echo "Error: check dirnames"; exit 1; }
destdir="$wrkdir/Pline_zip"
[[ -d $destdir ]] || mkdir "$destdir"
echo "Copying..." #make 2 Pline copies
echo "  from: $srcdir"
echo "  to: $wrkdir"
rsync -a --exclude=".*" --exclude="analyses" --exclude="docs" --exclude="downloads" "$srcdir" "$wrkdir"
rsync -a --exclude=".*" --exclude="analyses" --exclude="docs" --exclude="downloads" "$srcdir" "$wrkdir/Pline"
#2. Archive all plugins (with linux or osx binaries)
echo "Zipping releases..."
echo "  to: $destdir"
cd "$wrkdir/Pline/Pline"
rm -rf "$destdir"/*.zip #cleanup
zip -r "$destdir/plugins_osx.zip" plugins -x "*/linux/*" &> /dev/null
zip -r "$destdir/plugins_linux.zip" plugins -x "*/osx/*" &> /dev/null
#3. Archive Pline + all plugins
cd "$wrkdir/Pline"
zip -r "$destdir/pline_bundle_osx.zip" Pline -x "*/linux/*" &> /dev/null
zip -r "$destdir/pline_bundle_linux.zip" Pline -x "*/osx/*" &> /dev/null
#archive single plugins
echo "Zipping plugins..."
pipeline="bwa_index bwa_mem samtools_index samtools_sort samtools_view"
for plugin in plugins/*/
do
  plugin=$(basename "$plugin") #plugindir name
  if [[ $plugin == 'pipelines' ]]; then
    continue
  elif [[ $plugin == '*' ]]; then
    exit 1 #no plugins
  else
    echo "  plugin: $plugin"
    zip -r "$destdir/${plugin}_osx.zip" "plugins/$plugin" -x "*/linux/*" &> /dev/null
    zip -r "$destdir/${plugin}_linux.zip" "plugins/$plugin" -x "*/osx/*" &> /dev/null
    rm -rf "$wrkdir"/Pline/Pline/plugins/* #empty temp. container
    if [[ $pipeline =~ $plugin ]]; then #part of pipeline
      cp -r "plugins/${plugin}" Pline/plugins #keep for later
    else
      mv "plugins/${plugin}" Pline/plugins
    fi
    zip -r "$destdir/pline_${plugin}_osx.zip" Pline -x "*/linux/*" &> /dev/null
    zip -r "$destdir/pline_${plugin}_linux.zip" Pline -x "*/osx/*" &> /dev/null
  fi
done
echo "Zipping pipeline..."
rm -rf "$wrkdir/Pline/Pline" #remove temp. container
cp "$srcdir/pline" "$wrkdir/Pline" #re-copy executable
cd "$wrkdir"
plname="read_mapping"
zip -r "$destdir/pline_${plname}_osx.zip" Pline -x "*/linux/*" &> /dev/null
zip -r "$destdir/pline_${plname}_linux.zip" Pline -x "*/osx/*" &> /dev/null
rm -rf "$wrkdir/Pline" #cleanup
echo "Done!"
