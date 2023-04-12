#### 使用多边形生成一幅图像的mask
```
figure; imshow(img, [])
roi = drawpolygon('Color','r'); % 使用鼠标选取感兴趣区域
[xx, yy] = meshgrid(1:size(img, 2), 1:size(img, 1));
index = inpolygon(xx, yy, roi.Position(:,1), roi.Position(:,2)); % 判断顶点是否在多边形里
interest.img = img(index);
interest.xx = xx(index);
interest.yy = yy(index);
figure(); imshow(img.*index, [])
```
