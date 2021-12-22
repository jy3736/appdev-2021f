from random import randrange

class CoffeeRoasting:
    def __init__(self, sRate=5):
        self.ns = [
            [220, 210, 30],
            [150, 90, 90],
            [155, 92, 30],
            [170, 95, 30],
            [190, 160, 180],
            [200, 170, 180],
            [205, 190, 60],
            [215, 200, 90],
            [220, 210, 60],
            [225, 220, 180],]
        self.k2, self.k1, self.kt1, self.kt2 = 220, 220, 210, 210
        self.state = 0
        self.rate = sRate
        self.step = 60//self.rate
        self.clk = -1*self.rate

    def next(self):
        self.clk += self.rate
        if self.k1 == self.kt1:
            self.kt2 = self.ns[self.state][0];
            self.kt1 = self.ns[self.state][1];
            self.step = self.ns[self.state][2]//self.rate;
            self.state+=1
        if self.state >= len(self.ns):
            self.state = 0
        if self.step >= 1:
            dt1 = (self.k1 - self.kt1) / self.step*randrange(1,3)
            dt2 = (self.k2 - self.kt2) / self.step
            self.k1 -= dt1           
            self.k2 -= dt2           
            if self.step == 1: 
                self.k1, self.k2 = self.kt1, self.kt2
            self.step-=1      
            self.k1 = float(f"{self.k1:5.1f}")
            self.k2 = float(f"{self.k2:5.1f}")
        return self.clk, self.k1, self.k2
