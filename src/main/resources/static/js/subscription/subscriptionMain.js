 document.addEventListener('DOMContentLoaded', function() {
        const items = document.querySelectorAll('.accordion-item');

        items.forEach(item => {
            item.addEventListener('click', function() {
                // Toggle the active class
                const body = this.lastElementChild;

                
                // Slide up all other accordion bodies
                document.querySelectorAll('.accordion-body').forEach(b => {
                    if (b !== body) {
                        b.classList.remove('open');
                        b.style.maxHeight = null;
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