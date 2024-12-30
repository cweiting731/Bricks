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
* 展示的 VGA 是 480 * 640 的，預計只使用黑白
* 為了計算方便，這邊每 40 * 40 壓縮成一個 unit，所以遊戲畫面控制計算使用的陣列是 12 * 16 的
* 因為 module 不能 input output 陣列，所以會將 data 放成一個 [191:0] 的數值，需要在各自的 module 轉換成適當的列跟行 (e.g. 第一列: [15:0] 、第二列: [31:16]、......) 麻煩大家了~~~
* data 裡面，如果值是 0 代表該處是空的，如果值是 1 代表該處有東西 (Plate, Ball or Bricks)
* ⚠️ **計算的時候務必參照圖片的 row 跟 column 的排序** ⚠️

![download](https://github.com/user-attachments/assets/0c18f561-124a-4683-ae46-1bbdc985c48c)
