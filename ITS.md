
#1. Подгружаем данные последовательностей
```
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path manifest_file.tsv \
--output-path paired-end-demux.qza \
--input-format PairedEndFastqManifestPhred33V2
```
#2. Удаляем праймеры
```
 qiime cutadapt trim-paired \
--i-demultiplexed-sequences paired-end-demux.qza \
--p-front-f GCATCGATGAAGAACGCAGC \
--p-front-r TCCTCCGCTTATTGATATGC \
--o-trimmed-sequences demux-trimmed.qza
```
#3.Статистика
```
qiime demux summarize \
--i-data demux-trimmed.qza \
--o-visualization demux-trimmed.qzv 
```
#4. Обрезка
```
qiime itsxpress trim-pair-output-unmerged\
  --i-per-sample-sequences demux-trimmed.qza \
  --p-region ITS2 \
  --p-taxa F \
  --o-trimmed itsxpress_trimmed.qza
```
#5. Статистика
```
qiime demux summarize \
--i-data itsxpress_trimmed.qza \
--o-visualization itsxpress_trimmed.qzv 
```
#6. Шумоподавление
```
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs itsxpress_trimmed.qza \
  --p-trunc-len-f 165 \
  --p-trunc-len-r 160 \
  --output-dir dada2out
```

#Статистика
```
qiime feature-table summarize \
  --i-table dada2out/table.qza \
  --o-visualization tableviz.qzv

qiime metadata tabulate \
--m-input-file dada2out/denoising_stats.qza \
--o-visualization denoising-stats.qzv

qiime feature-table tabulate-seqs \
  --i-data dada2out/representative_sequences.qza \
  --o-visualization rep-seqs.qzv
```
#7. Таксономия
```
qiime feature-classifier classify-sklearn   --i-classifier /home/evgeniy/Desktop/Kseniya/Aspa/metagenomics/classifier/unite-classifier-ver9_99_16.10.2022.qza   --i-reads dada2out/representative_sequences.qza   --o-classification taxonomy.qza

qiime taxa barplot \
--i-table dada2out/table.qza \
--i-taxonomy taxonomy.qza \
--o-visualization bar-plot.qzv
```
