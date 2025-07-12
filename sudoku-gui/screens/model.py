class Model:
    start = False
    diffculty = False
    answer_key = [[]]

    def receivedAnswerKey(self):
        if self.answer_key.count() < 8 :
            return False
        else :
            return True
    
