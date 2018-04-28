# Computer Final Project Report

組別：2
羅右鈞 105062509
廖翊廷 103066512

## Introduction

本專案使用 python 套件，從無到有手刻 deep learning model 來學習 edge（簡單線條及色塊的人臉圖片） 跟 face （真實人臉圖片） 之間的轉換，我們試圖將這樣的 model 能夠應用在只要讓使用者去畫一些簡單人臉的線條，就能夠讓依據這些線條來產生真實人臉的圖片。下圖為 model 產生的結果：

![](https://i.imgur.com/N4VcgFt.png)

## Related Works
Generative Adversarial Network (GAN) 是 2014 年由 Ian GoodFellow [5] 所提出來訓練 generative model 的方式，但是有一些缺點，像是 GAN 在訓練上的穩定度不佳、難以訓練的問題，還有不能給予適時的條件來產生我們想要的資料，因此到後來就有 Improved Techniques for Training GANs [6] 以及Conditional GAN [7] 的研究來解決上述這些問題，後續更有 Unsupervised Representation Learning with Deep Convolutional Generative Adversarial Networks [8] 提出訓練 GAN 的建議架構，還有 Image-to-Image Translation with Conditional Adversarial Networks [9] 沿用上述論文所提出來的訓練 GAN 的技巧以及架構來做出應用。

## Contributions
本專案基於上述幾篇論文所提供的訓練 GAN 的技巧與方法，用 Tensorflow 實作出 cGAN，不過與 paper 中的架構並不是完全相同，參數也有做一些調整，最後成功利用 cGAN 做出有趣的應用，也就是用簡單人臉的線條來產生出真實人臉的圖片，算是 cGAN 在應用上的拓展。

## Datasets
使用 JAFFE datasets [1]，共有 190 張 256x256 grayscale 人臉圖片。

## Preprocessing
使用 scikit image 所提供的 adaptive threshold 來產生 face images 對應的 edge images（在此專案中已經附上處理好的 dataset，可直接訓練及測試）

## Model Architecture
在 GAN 中，主要有兩個 neural networks，一個是 discriminative model - D，另一個是 generative model - G。在訓練的過程中，D 會輸入兩對 image pairs，一對為 real edge image (real A) 所對應的 real face image (real B)，另一對為 real A 與 G 生成的 fake face image (fake B)，D 會從這兩對中學習哪一對是真的、哪一對是假的，而 G 也盡可能地希望所產生出來的 fake B 能夠騙過 D，而騙過 D 的時候，代表所產生的 fake B 是近似於 real face image，因此最後得已產生真實人臉的照片。以下為 D, G 的架構：

### Discriminator（Deep CNN) `model.py discriminator()`:

第一層
- **input (256x256x2) grayscal image**，channel 為 2 是因為 image pair A, B concatenate 在 channel dimension 中，而我們所用的 dataset 的 image 都為 grayscale，因此為 1+1=2。
- **convolution 2D**, with **64 (5x5) filters** and **stride (2,2)** 來取代傳統 max-pooling layer，主要是希望能夠讓 neural net 自動地學習 down-sampling。
- **leaky relu** with **slope 0.2**

第二層
- **convolution 2D**, with **128 (5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**
- **leaky relu** with **slope 0.2**

第三層
- **convolution 2D**, with **256 (5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**
- **leaky relu** with **slope 0.2**

第四層 
- **convolution 2D**, with **512 (5x5) filters** and **stride (1,1)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**
- **leaky relu** with **slope 0.2**

第五層
- flatten to vector
- **fully-connected neural net** with **normal distribution** weight initializer with **standard deviation 0.02**
- **sigmoid**

### Generator（Deep Convolutional Auto-Encoder) `model.py generator()`:

Encoder 第一層
- **input (256x256x1) grayscal image**，主要是 input edge image
- **convolution 2D**, with **64 (5x5) filters** and **stride (2,2)**

Encoder 第二層
- **leaky relu** with **slope 0.2**
- **convolution 2D**, with **128 (5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**

Encoder 第三層
- **leaky relu** with **slope 0.2**
- **convolution 2D**, with **256 (5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**

Encoder 第四層、第五層、第六層、第七層、第八層
- **leaky relu** with **slope 0.2**
- **convolution 2D**, with **512 (5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**

Decoder 第一層
- **relu**
- **deconvolution 2D** with output shape **(2x2x512)**, **(5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**
- **dropout** with **rate 0.5**

Decoder 第二層
- input **encoder 第七層 與 decoder 第一層** 的 output，concatenate 在 channel dimension。
- **relu**
- **deconvolution 2D** with **output shape (4x4x512)**, **(5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**
- **dropout** with **rate 0.5**

Decoder 第三層
- input **encoder 第六層 與 decoder 第二層** 的 output，concatenate 在 channel dimension。
- **relu**
- **deconvolution 2D** with **output shape (8x8x512)**, **(5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**
- **dropout** with **rate 0.5**

Decoder 第四層
- input **encoder 第五層 與 decoder 第三層** 的 output，concatenate 在 channel dimension。
- **relu**
- **deconvolution 2D** with **output shape (16x16x512)**, **(5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**
- **dropout** with **rate 0.5**

Decoder 第五層
- input **encoder 第四層 與 decoder 第四層** 的 output，concatenate 在 channel dimension。
- **relu**
- **deconvolution 2D** with **output shape (32x32x256)**, **(5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**

Decoder 第六層
- input **encoder 第三層 與 decoder 第五層** 的 output，concatenate 在 channel dimension。
- **relu**
- **deconvolution 2D** with **output shape (64x64x128)**, **(5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**

Decoder 第七層
- input **encoder 第二層 與 decoder 第六層** 的 output，concatenate 在 channel dimension。
- **relu**
- **deconvolution 2D** with **output shape (128x128x64)**, **(5x5) filters** and **stride (2,2)**
- **batch normalization** with **epsilon 1e-5**, **momentum 0.9**

Decoder 第八層
- input **encoder 第一層 與 decoder 第七層** 的 output，concatenate 在 channel dimension。
- **relu**
- **deconvolution 2D** with **output shape (256x256x1)**, **(5x5) filters** and **stride (2,2)**
- **tanh**

## Training settings `model.py train()`
- Training 的時間大概為 30 幾個小時
- 每一次跑 15 個 epoches 看看結果如何（可中途停止看，因為有寫 auto-save model 的機制）
- batch size = 1

## Objectives `model.py build_model()`
![](https://i.imgur.com/J2FOhTY.png)
![](https://i.imgur.com/SYKaWIH.png)

其中 L1 loss lambda 設為 100

## Optimizers `model.py train()`
Discriminator 跟 Generator 皆使用 **Adam** optimizer with **learning_rate=0.0002, beta1=0.5**

## Results

### Inputs:
![](https://i.imgur.com/zXyTufR.jpg)
![](https://i.imgur.com/qLztbk8.jpg)
![](https://i.imgur.com/H38ohZa.jpg)
![](https://i.imgur.com/SbKtmbD.jpg)
![](https://i.imgur.com/YW6QcNt.jpg)

### Outputs:
根據上面 inputs 順序
![](https://i.imgur.com/eFIIAj3.jpg)
![](https://i.imgur.com/CVi4h2E.jpg)
![](https://i.imgur.com/2uuBOe5.jpg)
![](https://i.imgur.com/jrqsA6t.jpg)
![](https://i.imgur.com/rMVb3pB.jpg)

### For fun
![](https://i.imgur.com/SCxfOjz.png)
![](https://i.imgur.com/HrhhKwl.png)

## Development Environment
本程式使用 python 2.7.10 開發以及其他 python 套件：
- numpy 1.11.13（矩陣運算）
- tensorflow 0.12.1（建立 deep learning model）
- scikit-image 0.13.3 (影像處理)

## Folder & Scripts Intro.

- `datasets/`:
    - `input/`: 放 edge 的圖片 (256x256)。
    - `output/`: 根據 `input/` 給的 edge 產生 face 的圖片 (256x512)。
    - `train/`: 訓練資料，放 face, edge 結合的圖片 (256x512)。

- `model/`: tensorflow 存取 model 的地方。在訓練階段時，每 update model parameters 五次就會自動儲存 model 的 parameters；在測試階段時，tensorflow 會從此處讀取 model。

- `data_utils.py`: 一些 data preprocessing, loading, saving 的 helper functions。

- `activations.py`: tensorflow activation functions wrapper for deep learning model。

- `model.py`: 主要用 tensorflow 建立、訓練以及測試 model 的地方。

- `main.py`: 程式的進入點，在 terminal 輸入以下指令來訓練以及測試 model：

程式內皆負上詳細的註解，如 report 有不明的地方可參考程式碼。

## 如何執行程式 
```
$ python main.py --phase train （訓練 model）
$ python main.py --phase test （測試 model，產生結果在 "datasets/output/"）
```

## References
- [1] [The Japanese Female Facial Expression (JAFFE) Database](http://www.kasrl.org/jaffe.html)
- [2] [scikit-image](http://scikitimage.org/download.html)
- [3] [numpy](http://www.numpy.org/)
- [4] [TensorFlow](https://www.tensorflow.org)
- [5] [Generative Adversarial Networks](https://arxiv.org/abs/1406.2661) 
- [6] [Improved Techniques for Training GANs](https://arxiv.org/abs/1606.03498)
- [7] [Conditional Generative Adversarial Nets](https://arxiv.org/abs/1411.1784)
- [8] [Unsupervised Representation Learning with Deep Convolutional Generative Adversarial Networks](https://arxiv.org/abs/1511.06434)
- [9] [Image-to-Image Translation with Conditional Adversarial Networks](https://arxiv.org/pdf/1611.07004v1.pdf)