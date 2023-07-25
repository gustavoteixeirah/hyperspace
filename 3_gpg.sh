gpg --generate-key

gpg -k --keyid-format=long


echo From the output: `pub ed25519/{YOUR_KEY_ID}`, Enter {YOUR_KEY_ID}
read keyId

gpg --export -a $keyId

echo Copy the output entire output including BEGIN and END lines end put in the GPG section of your Github account

echo Have you done it?
read isDone


git config --global user.signingkey $keyId
git config --global commit.gpgsign true

echo Add export GPG_TTY=$TTY to you .zshrc
export GPG_TTY=$TTY