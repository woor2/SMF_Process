
        // 사용자의 카메라에 액세스하여 비디오를 스트리밍합니다.
        navigator.mediaDevices.getUserMedia({ video: true })
        .then(function (stream) {
                var videoElement = document.getElementById('videoElement');
                videoElement.srcObject = stream;

                // QR 코드 인식 및 처리
                const canvas = document.createElement('canvas');
                const context = canvas.getContext('2d');
                const qrCodeDataElement = document.createElement('div');
                qrCodeDataElement.style.color = 'white';
                qrCodeDataElement.style.fontSize = '24px';
                qrCodeDataElement.style.fontWeight = 'bold';
                qrCodeDataElement.style.textShadow = '2px 2px 4px #000000';

                function decodeQRCode() {
                    context.drawImage(videoElement, 0, 0, canvas.width, canvas.height);
                    const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
                    const code = jsQR(imageData.data, imageData.width, imageData.height);
                    if (code) {
                        qrCodeDataElement.textContent = "인식된 QR 코드: " + code.data;
                        qrCodeDataElement.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
                        qrCodeDataElement.style.padding = '10px';
                        qrCodeDataElement.style.position = 'absolute';
                        qrCodeDataElement.style.bottom = '10px';
                        qrCodeDataElement.style.left = '10px';
                        qrCodeDataElement.style.display = 'flex';
                        qrCodeDataElement.style.alignItems = 'center';
                        qrCodeDataElement.style.justifyContent = 'center';
                        qrCodeDataElement.style.pointerEvents = 'none';
                        qrCodeDataElement.style.borderRadius = '5px';
                    } else {
                        qrCodeDataElement.textContent = '';
                        qrCodeDataElement.style.backgroundColor = '';
                        qrCodeDataElement.style.padding = '';
                        qrCodeDataElement.style.position = '';
                        qrCodeDataElement.style.bottom = '';
                        qrCodeDataElement.style.left = '';
                        qrCodeDataElement.style.display = '';
                        qrCodeDataElement.style.alignItems = '';
                        qrCodeDataElement.style.justifyContent = '';
                        qrCodeDataElement.style.pointerEvents = '';
                        qrCodeDataElement.style.borderRadius = '';
                    }

                    requestAnimationFrame(decodeQRCode);
                }

                decodeQRCode();
                document.body.appendChild(qrCodeDataElement);
            })
            .catch(function (error) {
                console.error('카메라 액세스 오류:', error);
            });
 