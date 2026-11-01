clc;
close all;
clear all;
im = imread("img1.jpg");
gray = im2gray(im); 
figure;
imshow(gray);
BW = edge(gray, 'canny'); 
figure;
imshow(BW);
title('Binary Edge Map');
theta = 0:0.5:179.5; 
[R, xp] = radon(BW, theta); 
[maxValue, maxIdx] = max(R(:));
[rhoIdx, thetaIdx] = ind2sub(size(R), maxIdx);
theta_lines = theta(thetaIdx);
rho_dominant = xp(rhoIdx);
disp("Dominant Line Found:");
disp("Angle PERPENDICULAR to line (\theta): " + theta_lines);
disp("Distance from origin (\rho): " + rho_dominant);
figure;
imagesc(theta, xp, R);
title('Radon Transform Accumulator');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(theta_lines, rho_dominant, 's', 'color', 'white', 'LineWidth', 2);
skew_angle = theta_lines - 90;
if skew_angle > 45
    skew_angle = skew_angle - 180;
end
if skew_angle < -45
    skew_angle = skew_angle + 180;
end
rotation_angle = -skew_angle;
disp("Skew Angle of Text: " + skew_angle + " degrees");
disp("Required Rotation Angle: " + rotation_angle);
I_corrected = imrotate(gray, rotation_angle, 'bilinear', 'crop');
if ~isa(I_corrected, 'uint8')
    I_corrected = uint8(I_corrected);
end
mask = (I_corrected == 0);
I_corrected(mask) = 255; 
figure;
subplot(1,2,1);
imshow(gray);
title('Original Grayscale Image');
subplot(1,2,2);
imshow(I_corrected);
title('Deskewed Image (Corrected)');