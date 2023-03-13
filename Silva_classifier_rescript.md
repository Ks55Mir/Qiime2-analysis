# Подготовка таксономического классификатора на данных базы Silva с помощью плагина rescript

### Скачиваем базу данных silva
https://github.com/bokulich-lab/RESCRIPt
```
qiime rescript get-silva-data \
    --p-version '138.1' \
    --p-target 'SSURef_NR99' \
    --p-include-species-labels \
    --o-silva-sequences silva-138.1-ssu-nr99-rna-seqs.qza \
    --o-silva-taxonomy silva-138.1-ssu-nr99-tax.qza

qiime rescript reverse-transcribe \
    --i-rna-sequences silva-138.1-ssu-nr99-rna-seqs.qza \
    --o-dna-sequences silva-138.1-ssu-nr99-seqs.qza
 ```
    
### Удаляем некачественные последовательности 
 ```   
    qiime rescript cull-seqs \
    --i-sequences silva-138.1-ssu-nr99-seqs.qza \
    --o-clean-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza
 ```
 
 ### Дифференцированно фильтруем на основе таксономии эталонных последовательностей 
 ```
qiime rescript filter-seqs-length-by-taxon \
    --i-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza \
    --i-taxonomy silva-138.1-ssu-nr99-tax.qza \
    --p-labels Archaea Bacteria Eukaryota \
    --p-min-lens 900 1200 1400 \
    --o-filtered-seqs silva-138.1-ssu-nr99-seqs-filt.qza \
    --o-discarded-seqs silva-138.1-ssu-nr99-seqs-discard.qza 
    
 ```
 ### Удаляем избыточные последовательности
 ``` 
    qiime rescript dereplicate \
  --i-sequences silva-138.1-ssu-nr99-seqs-filt.qza  \
  --i-taxa silva-138.1-ssu-nr99-tax.qza \
  --p-rank-handles 'silva' \
  --p-mode 'uniq' \
  --o-dereplicated-sequences silva-138.1-ssu-nr99-seqs-derep-uniq.qza \
  --o-dereplicated-taxa silva-138.1-ssu-nr99-tax-derep-uniq.qza
  
 ```
  ### Ограничиваем классификатор, только областью наших ампликонов
 ``` 
qiime feature-classifier extract-reads \
   --i-sequences silva-138.1-ssu-nr99-seqs-derep-uniq.qza \
   --p-f-primer GTGCCAGCMGCCGCGGTAA \
   --p-r-primer GGACTACVSGGGTATCTAAT \
   --p-n-jobs 2 \
   --p-read-orientation 'forward' \
   --o-reads silva-138.1-ssu-nr99-seqs-515f-806r.qza
```   
 ### Опять удаляем избыточные последовательности  
```
qiime rescript dereplicate \
  --i-sequences silva-138.1-ssu-nr99-seqs-515f-806r.qza \
  --i-taxa silva-138.1-ssu-nr99-tax-derep-uniq.qza \
  --p-rank-handles 'silva' \
  --p-mode 'uniq' \
  --o-dereplicated-sequences silva-138.1-ssu-nr99-seqs-515f-806r-uniq.qza \
  --o-dereplicated-taxa  silva-138.1-ssu-nr99-tax-515f-806r-derep-uniq.qza
```  
 ### Тренируем классификатор
``` 
  qiime feature-classifier fit-classifier-naive-bayes \
 --i-reference-reads silva-138.1-ssu-nr99-seqs-515f-806r-uniq.qza \
 --i-reference-taxonomy silva-138.1-ssu-nr99-tax-515f-806r-derep-uniq.qza \
 --o-classifier silva-138.1-ssu-nr99-515f-806r-classifier.qza
``` 
 
