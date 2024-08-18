document.addEventListener('DOMContentLoaded', function() {
    const headers = document.querySelectorAll('.accordion-header');

    headers.forEach(header => {
        header.addEventListener('click', function() {
            // Toggle the active class
            const body = this.nextElementSibling;
            
            // Slide up all other accordion bodies
            document.querySelectorAll('.accordion-body').forEach(b => {
                if (b !== body) {
                    b.classList.remove('open');
                    b.style.maxHeight = null;
                    
                    // Change the direction of the other headers' arrows to ▼
                    b.previousElementSibling.querySelector('.align-right').innerText = '▼';
                }
            });

            // Slide down the clicked accordion body
            if (body.classList.contains('open')) {
                body.classList.remove('open');
                body.style.maxHeight = null;
                this.querySelector('.align-right').innerText = '▼';
            } else {
                body.classList.add('open');
                body.style.maxHeight = body.scrollHeight + 'px';
                this.querySelector('.align-right').innerText = '▲';
            }
        });
    });
});
