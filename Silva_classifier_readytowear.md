
# Классисификатор с весами 
Готовые таксономические веса можно найти здесь: https://github.com/BenKaehler/readytowear


## Классификация с использованием классификатора с весами
```
#Get weights
git clone https://github.com/BenKaehler/readytowear.git

# натренировать классификатор с учетом plant-corpus.qza, долго выполняется
qiime feature-classifier fit-classifier-naive-bayes \
   --i-reference-reads readytowear/data/silva_138_1/515f-806r/ref-seqs.qza \
   --i-reference-taxonomy readytowear/data/silva_138_1/515f-806r/ref-tax.qza\
   --i-class-weight readytowear/data/silva_138_1/515f-806r/plant-corpus.qza \
   --o-classifier silva_138_1_plant-corpus_classifier.qza

qiime feature-classifier classify-sklearn \
--i-classifier /home/evgeniy/Desktop/Metagenomics/new_data/16S/classifier_with_weight/silva_138_1_plant-corpus_classifier.qza \
--i-reads rep-seqs.qza \
--o-classification taxonomy_weight_classifier.qza

qiime taxa barplot \
--i-table table.qza \
--i-taxonomy taxonomy_weight_classifier.qza \
--o-visualization taxa-bar-plots.qzv
```
### По тому же принципу был построен классификатор, специфичный для "Plant Surface".
