source $stdenv/setup

sources_=($sources)
targets_=($targets)

objects=($objects)
symlinks=($symlinks)
branch="$type/$id/$system"

# Remove the initial slash from a path, since genisofs likes it that way.
stripSlash() {
    res="$1"
    if test "${res:0:1}" = /; then res=${res:1}; fi
}

# Add the individual files.
for ((i = 0; i < ${#targets_[@]}; i++)); do
    stripSlash "${targets_[$i]}"
    mkdir -p "$(dirname "$res")"
    cp -a "${sources_[$i]}" "$res"
done


# Add the closures of the top-level store objects.
chmod +w .
mkdir -p nix/store
for i in $(< $closureInfo/store-paths); do
    cp -a "$i" "${i:1}"
done


# TODO tar ruxo
# Also include a manifest of the closures in a format suitable for
# nix-store --load-db.
cp $closureInfo/registration nix-path-registration

# Add symlinks to the top-level store objects.
for ((n = 0; n < ${#objects[*]}; n++)); do
    object=${objects[$n]}
    symlink=${symlinks[$n]}
    if test "$symlink" != "none"; then
        mkdir -p $(dirname ./$symlink)
        ln -s $object ./$symlink
    fi
done

$extraCommands

mkdir -p $out/ostree-repo

rm env-vars

time ostree init --mode archive-z2 --repo=$out/ostree-repo
time ostree commit -b $branch --tree=dir=$(pwd)
