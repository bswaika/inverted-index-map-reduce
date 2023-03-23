import re

from mrjob.job import MRJob, RawValueProtocol

class InvertedIndexJob(MRJob):
    OUTPUT_PROTOCOL = RawValueProtocol
    def clean(self, text:str):
        text = text.lower()
        text = re.sub('[^a-z0-9\'-]', ' ', text)
        text = re.sub('-', '', text)
        text = re.sub('[\s]{2,}', ' ', text)
        text = re.sub('\'', ' ', text)
        text = re.sub('^\s+', '', text)
        text = re.sub('\s[0-9]+\s', ' ', text)
        text = re.sub('^[0-9]+\s', '', text)
        text = re.sub('\s[0-9]+$', '', text)
        return text
    
    def tokenize(self, text:str):
        return text.split(' ')

    def mapper(self, key, value):
        doc_id, document = str(value).split('\t', 1)
        document = self.clean(document)
        document = self.tokenize(document)
        for word in document:
            yield word, doc_id
    
    def reducer(self, key, values):
        count_dict = {}
        for doc_id in values:
            if doc_id not in count_dict:
                count_dict[doc_id] = 0
            count_dict[doc_id] += 1
        yield key, ' '.join([key] + [f'{doc_id}:{count}' for doc_id, count in count_dict.items()])        
    
if __name__ == '__main__':
    InvertedIndexJob.run()