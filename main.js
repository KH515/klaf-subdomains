const faqs = {
  ar: [
    { question: "هل تواجه مشكلة عند تسجيل الدخول؟", answers: ["تأكد من صحة البريد وكلمة المرور.", "إعادة تعيين كلمة المرور إذا نسيتها."] },
    { question: "كيف أطلب منتج بالجملة؟", answers: ["املأ نموذج الطلب بالجملة.", "أو اتصل بخدمة العملاء."] }
  ],
  en: [
    { question: "Do you face login issues?", answers: ["Check your email and password.", "Reset password if forgotten."] },
    { question: "How to order in bulk?", answers: ["Fill bulk order form.", "Or call customer service."] }
  ]
};

let currentLang = 'ar';
const faqContainer = document.getElementById('faq-container');

function renderFaq() {
  if(!faqContainer) return;
  faqContainer.innerHTML = '';
  faqs[currentLang].forEach(faq => {
    const item = document.createElement('div');
    item.className = 'accordion-item';
    const header = document.createElement('div');
    header.className = 'accordion-header';
    header.textContent = faq.question;
    const content = document.createElement('div');
    content.className = 'accordion-content';
    faq.answers.forEach(ans => {
      const p = document.createElement('p');
      p.textContent = ans;
      content.appendChild(p);
    });
    item.appendChild(header);
    item.appendChild(content);
    faqContainer.appendChild(item);
  });

  document.querySelectorAll('.accordion-header').forEach(header => {
    header.addEventListener('click', ()=>{
      header.classList.toggle('active');
      const content = header.nextElementSibling;
      if(header.classList.contains('active')){
        content.style.maxHeight = content.scrollHeight + 'px';
      } else {
        content.style.maxHeight = 0;
      }
    });
  });
}

renderFaq();