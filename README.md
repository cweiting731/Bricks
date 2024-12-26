# Bricks
Digital System Lab Project

## 配置
* FPGA chip: 10M50DAF484C7G
* Device Family: MAX 10 (DA/DF/DC/SA/SC)

## 注意事項
* 計算score時需要設置其範圍為 0~999
* control 會有 5 種數值
    * 4'b1111 : 常態停止，speed = 0
    * 4'b0011 : 向右，speed = 2 (keyPad按鍵 - 7)
    * 4'b0001 : 向右，speed = 1 (keyPad按鍵 - 4)
    * 4'b0100 : 向左，speed = 1 (keyPad按鍵 - 1)
    * 4'b0110 : 向左，speed = 2 (keyPad按鍵 - 0)