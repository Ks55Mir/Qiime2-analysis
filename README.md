# Qiime2-analysis
Обработка метагеномных данных на этапе готовых OTU

Исходные файлы:
  1. OTUs_uparse.fa 
  2. OTU_table_uparse.txt
  
активировать qiime2
```
conda activate qiime2-2022.8
```
## Классификация таксонов

#### Тренируем классификатор с UNITE ITS Reference Sequences, следуя туториалу:
https://john-quensen.com/tutorials/training-the-qiime2-classifier-with-unite-its-reference-sequences/?sfw=pass1669095455

Скачали референсные файлы UNITE version 9.0, release date October 16, 2022 (https://unite.ut.ee/repository.php)

В документации qiime2 есть следующее замечание:

>**Classification of fungal ITS sequences:**
In our experience, fungal ITS classifiers trained on the UNITE reference database do NOT benefit from extracting/trimming reads to primer sites. We recommend training UNITE classifiers on the full reference sequences. Furthermore, we recommend the “developer” sequences (located within the QIIME-compatible release download) because the standard versions of the sequences have already been trimmed to the ITS region (excluding portions of flanking rRNA genes that may be present in amplicons generated with standard ITS primers)https://docs.qiime2.org/2020.2/tutorials/feature-classifier/
>

Следуя этому замечанию, идем в папку /developer, выбираем подходящии файлы и тренируем классификатор.

#### Импорт файлов из базы данных для классификатора, нам нужны сами последовательности и таксономия
```  
qiime tools import \
--type FeatureData[Sequence] \
--input-path sh_refs_qiime_ver9_99_16.10.2022_dev.fasta \
--output-path unite-ver9-seqs_16.10.2022.qza

qiime tools import \
--type FeatureData[Taxonomy] \
--input-path sh_taxonomy_qiime_ver9_99_16.10.2022_dev.txt \
--output-path unite-ver9-taxonomy_99_16.10.2022.qza \
--input-format HeaderlessTSVTaxonomyFormat
```

#### Тренируем классификатор

```
qiime feature-classifier fit-classifier-naive-bayes \
--i-reference-reads unite-ver9-seqs_16.10.2022.qza \
--i-reference-taxonomy unite-ver9-taxonomy_99_16.10.2022.qza \
--o-classifier unite-ver9-99-classifier-16.10.2022.qza
```

#### Импорт наших исходных файлов
```
qiime tools import \
--type FeatureData[Sequence] \
--input-path OTUs_uparse.fa \
--output-path OTUs.qza
```
#### Классификация наших данных
```
qiime feature-classifier classify-sklearn \
--i-classifier unite-ver9-99-classifier-16.10.2022.qza \
--i-reads OTUs.qza \
--o-classification taxonomy_with_classifier.qza
```

#### Посмотреть результаты классификации: 
```
qiime metadata tabulate \
--m-input-file taxonomy_with_classifier.qza \
--o-visualization taxonomy_with_classifier.qzv
```
Подгрузить и посмотреть файл taxonomy_with_classifier.qzv в https://view.qiime2.org/


## Построение графика
#### Преобразование OTU table в biom
```
biom convert -i OTU_table_uparse.txt -o OTU_table_uparse.biom --to-hdf5 --table-type "OTU table"
```

#### Импорт FeatureTable (biom)
```
qiime tools import \
--input-path OTU_table_uparse.biom \
--type 'FeatureTable[Frequency]' \
--input-format BIOMV210Format \
--output-path OTU-table.qza
```
#### Построить график
```
qiime taxa barplot \
--i-table OTU-table.qza \
--i-taxonomy taxonomy_with_classifier.qza \
--o-visualization taxa-bar-plots.qzv
```
Подгрузить и посмотреть файл taxa-bar-plots.qzv в https://view.qiime2.org/
