
    const track = document.getElementById('slidesTrack');
    const slides = document.querySelectorAll('.insight-slide');
    const dotsContainer = document.getElementById('slideDots');
    const prevButton = document.getElementById('prevSlide');
    const nextButton = document.getElementById('nextSlide');

    let currentSlide = 0;

    function createDots() {
        slides.forEach(function (_, index) {
            const dot = document.createElement('button');
            dot.type = 'button';
            dot.className = index === 0 ? 'dot active' : 'dot';

            dot.addEventListener('click', function () {
                goToSlide(index);
            });

            dotsContainer.appendChild(dot);
        });
    }

    function updateDots() {
        const dots = document.querySelectorAll('.dot');

        dots.forEach(function (dot, index) {
            dot.classList.toggle('active', index === currentSlide);
        });
    }

    function goToSlide(index) {
        if (index < 0) {
            currentSlide = slides.length - 1;
        } else if (index >= slides.length) {
            currentSlide = 0;
        } else {
            currentSlide = index;
        }

        track.style.transform = 'translateX(-' + (currentSlide * 100) + '%)';
        updateDots();
    }

    prevButton.addEventListener('click', function () {
        goToSlide(currentSlide - 1);
    });

    nextButton.addEventListener('click', function () {
        goToSlide(currentSlide + 1);
    });

    createDots();

    setInterval(function () {
        goToSlide(currentSlide + 1);
    }, 6500);
