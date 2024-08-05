SENTENCES="sentences"

echo "Tokenizing sentences from $SENTENCES.txt"
cat "$SENTENCES".txt | sed -f en/tokenizer.sed > "$SENTENCES".tok
~/workspaces/learningbyreading/ext/candc/bin/candc \
    --models ~/workspaces/learningbyreading/ext/candc/models \
    --candc-printer xml \
    --input "$SENTENCES".tok > "$SENTENCES".candc.xml

echo "Translating candc xml to transccg xml"
python en/candc2transccg.py "$SENTENCES".candc.xml > "$SENTENCES".xml

echo "Producing semantic representations"
python scripts/semparse.py "$SENTENCES".xml en/semantic_templates_en_emnlp2015.yaml "$SENTENCES".sem.xml

echo "Running automated reasoning to determine if conclusion follows from premises"
python scripts/prove.py "$SENTENCES".sem.xml --graph_out "$SENTENCES".graphdebug.html
