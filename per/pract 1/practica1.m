#!/usr/bin/octave -qf
load("trdata.mat.gz");
# trdata
# name: X
# type: matrix
# rows: 256
# columns: 7291
size(X);
load("tedata.mat.gz");
# tedata
# name: Y
# type: matrix
# rows: 256
# columns: 2006
load("trlabels.mat.gz");
# trlabels
# name: xl
# type: matrix
# rows: 1
# columns: 7291
load("telabels.mat.gz");
# trlabels
# name: yl
# type: matrix
# rows: 1
# columns: 2006

x=X(:,100);
xr=reshape(x,16,16);
imshow(xr',[])

