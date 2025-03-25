import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class MySubscribeScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg',
    'https://images.unsplash.com/photo-1575936123452-b67c3203c357?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8JTIzaW1hZ2V8ZW58MHx8MHx8fDA%3D',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFYqoKTu_o3Zns2yExbst2Co84Gpc2Q1RJbA&s',
    'https://images.ctfassets.net/hrltx12pl8hq/28ECAQiPJZ78hxatLTa7Ts/2f695d869736ae3b0de3e56ceaca3958/free-nature-images.jpg?fit=fill&w=1200&h=630',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            imageUrls[index], // imageUrls 리스트 사용
            fit: BoxFit.cover,
          );
        },
        itemCount: imageUrls.length, // 리스트 길이만큼 설정
        viewportFraction: 0.8,
        scale: 0.9,
        pagination: SwiperPagination(),
        control: SwiperControl(),
      ),
    );
  }
}
