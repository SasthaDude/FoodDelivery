import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';


///---------------------- SPLASH SCREEN ---------------------------///

class FOODAPP extends StatefulWidget {
  FOODAPP({Key? key}) : super(key: key);

  @override
  State<FOODAPP> createState() => _FOODAPPState();
}

class _FOODAPPState extends State<FOODAPP> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Slower animation duration to simulate slower GIF appearance
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000), // Increased duration for slower effect
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Start the animation
    _controller.forward();

    // Navigate to home page after 6 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(
          context,
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: ClipOval( // Clip the container to be circular
                child: Image.asset(
                  SplashScreenImage(String, context),
                  height: ResponsiveValue<double>(
                    context,
                    defaultValue: 350.0,
                    valueWhen: const [
                      Condition.smallerThan(name: MOBILE, value: 300.0),
                      Condition.largerThan(name: TABLET, value: 400.0),
                    ],
                  ).value,
                  width: ResponsiveValue<double>(
                    context,
                    defaultValue: 350.0,
                    valueWhen: const [
                      Condition.smallerThan(name: MOBILE, value: 300.0),
                      Condition.largerThan(name: TABLET, value: 400.0),
                    ],
                  ).value,
                  fit: BoxFit.cover, // Ensure the GIF fits within the circular container
                ),
              ),
            ),
          ),
        ),
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
        ],
      ),
    );
  }
}


///--------------------------- SIGNUP PAGE ------------------------------///


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordsMatch = true;
  String? _errorMessage;
  bool _isPasswordVisible = false; // Manage password visibility
  bool _isConfirmPasswordVisible = false; // Manage confirm password visibility

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(SignUpLoginBackGroundImage(String, context),
                    //'assets/FOODAPPimages/signupbackground.jpeg'
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0.w), // Use ScreenUtil for padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 130.h), // Use ScreenUtil for height
                  Text(
                    '🍔 Food Delivery',
                    style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: HeadingTextColor(context, Color)),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Signup to Get Started!',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white70),
                  ),
                  SizedBox(height: 100.h),

                  // Username Input
                  _buildTextFormField(controller: _usernameController, label: 'Username', icon: Icons.person),
                  SizedBox(height: 20.h),

                  // Password Input with Eye Icon
                  _buildPasswordTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    isVisible: _isPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),

                  // Confirm Password Input with Eye Icon
                  _buildPasswordTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    icon: Icons.lock_outline,
                    isVisible: _isConfirmPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),

                  if (!_passwordsMatch)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Passwords do not match', style: TextStyle(color: Colors.redAccent)),
                    ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(_errorMessage!, style: TextStyle(color: Colors.redAccent)),
                    ),
                  SizedBox(height: 40.h),

                  // Signup Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
                      });

                      if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                        setState(() {
                          _errorMessage = 'Username and password cannot be empty';
                        });
                        return;
                      }

                      if (!_passwordsMatch) {
                        setState(() {
                          _errorMessage = 'Passwords do not match';
                        });
                        return;
                      }

                      // Here you can add the logic to handle signup, e.g., saving credentials

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 16.h), // Use ScreenUtil for padding
                      backgroundColor: ButtonColor(context, Color),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: Text('Signup', style: TextStyle(fontSize: 18.sp, color: Colors.black)),
                  ),

                  SizedBox(height: 20.h),

                  // Already have an account? Log In button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to Login Page
                      );
                    },
                    child: Text('Already have an account? Log In', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for password TextField with visibility toggle
  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      obscureText: !isVisible, // Toggle visibility
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: SignupLoginIconColor(context, Color)),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: TextFormFieldBackGroundColor(context, Color),
        //Colors.white.withOpacity(0.3),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: SignupLoginIconColor(context, Color),
          ),
          onPressed: toggleVisibility, // Call the toggleVisibility function
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: SignupLoginIconColor(context, Color)),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: TextFormFieldBackGroundColor(context, Color),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}



///--------------------------- LOGIN PAGE ------------------------------///


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isPasswordVisible = false; // Manage password visibility

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(SignUpLoginBackGroundImage(String, context),
                    //'assets/FOODAPPimages/signupbackground.jpeg'
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0.w), // Use ScreenUtil for padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150.h), // Use ScreenUtil for height
                  Text(
                    '🍔 Food Delivery',
                    style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: HeadingTextColor(context, Color)),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Login to continue!',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white70),
                  ),
                  SizedBox(height: 100.h),

                  // Username Input
                  _buildTextFormField(controller: _usernameController, label: 'Username', icon: Icons.person),
                  SizedBox(height: 20.h),

                  // Password Input with Eye Icon
                  _buildPasswordTextField(),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(_errorMessage!, style: TextStyle(color: Colors.redAccent)),
                    ),
                  SizedBox(height: 40.h),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      // Validation logic (replace with your actual logic)
                      if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                        setState(() {
                          _errorMessage = 'Please enter your username and password.';
                        });
                        return;
                      }

                      // Clear error message and proceed to next step (e.g., navigation)
                      setState(() {
                        _errorMessage = null;
                      });

                      // After successful login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 16.h), // Responsive padding
                      backgroundColor: ButtonColor(context, Color),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: Text('Login', style: TextStyle(fontSize: 18.sp, color: Colors.black)),
                  ),

                  SizedBox(height: 20.h),

                  // Don't have an account? Sign Up button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()), // Navigate to SignUp Page
                      );
                    },
                    child: Text('Don’t have an account? Sign Up', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for the password TextField with visibility toggle
  Widget _buildPasswordTextField() {
    return TextFormField(
      cursorColor: Colors.white,
      controller: _passwordController,
      obscureText: !_isPasswordVisible, // Toggle visibility
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: SignupLoginIconColor(context, Color)),
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: TextFormFieldBackGroundColor(context, Color),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: SignupLoginIconColor(context, Color),
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
            });
          },
        ),
      ),
    );
  }

  // Helper method for text fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: SignupLoginIconColor(context, Color)),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: TextFormFieldBackGroundColor(context, Color),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}


///------------------------------ HOME PAGE ------------------------///


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppBackGroundImage(String, context)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // AppBar-like title section
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16), // Static padding
                  child: Center(
                    child: Text(
                      '🍽️ Restaurants',
                      style: TextStyle(
                        fontSize: 32, // Static font size
                        fontWeight: FontWeight.bold,
                        color: HeadingTextColor(context, Color),
                      ),
                    ),
                  ),
                ),
                // Welcome message
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8), // Static padding
                  child: Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 24, // Static font size
                      color: HeadingTextColor(context, Color),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Restaurant List
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16), // Static padding
                    children: [
                      _buildHotelCard(context, 'Food Hunt', 'assets/FOODAPPimages/foodhunt.jpeg'),
                      SizedBox(height: 20),
                      _buildHotelCard(context, 'Biryani Express', 'assets/FOODAPPimages/BiryaniExpress.jpeg'),
                      SizedBox(height: 20),
                      _buildHotelCard(context, 'Tandoori Tales', 'assets/FOODAPPimages/TandooriTales.jpeg'),
                      SizedBox(height: 20),
                      _buildHotelCard(context, 'Masala Magic Hotel', 'assets/FOODAPPimages/Noodles.jpeg'),
                      SizedBox(height: 20),
                      // Add more hotels here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create a styled card for each hotel
  Widget _buildHotelCard(BuildContext context, String hotelName, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to the new page with hotel name and dishes
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailPage(hotelName: hotelName),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: HotelCardColor(context, Color),
        //Colors.grey.withOpacity(0.8), // Semi-transparent for elegance
        elevation: 5, // Adds a shadow to make it more elevated
        child: Padding(
          padding: EdgeInsets.all(20), // Static padding
          child: Row(
            children: [
              // Hotel image
              ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 80, // Static width
                  height: 80, // Static height
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 20), // Static spacing
              // Hotel name
              Expanded(
                child: Text(
                  hotelName,
                  style: TextStyle(
                    fontSize: 20, // Static font size
                    fontWeight: FontWeight.bold,
                    color: HotelNameColor(context, Color),
                    //Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



///----------------------------INDIVIDUAL HOTEL PAGE ---------------------------------///


class HotelDetailPage extends StatelessWidget {
  final String hotelName;

  HotelDetailPage({required this.hotelName});

  // Map to hold food item images
  final Map<String, String> foodImages = {
    'Chicken Briyani': 'assets/FOODAPPimages/chickenbriyani.jpeg',
    'Grill Chicken': 'assets/FOODAPPimages/grill.jpeg',
    'Chicken Noodles': 'assets/FOODAPPimages/chickennoodles.jpeg',
    'Chicken Rice': 'assets/FOODAPPimages/rice.jpeg',
    'Tandoori': 'assets/FOODAPPimages/tandoori.jpeg',
    'Pizza': 'assets/FOODAPPimages/pizza.jpeg',
    'Burger': 'assets/FOODAPPimages/burger.jpeg',
  };

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>(); // Access cart provider

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppBackGroundImage(String, context)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // AppBar-like title section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      hotelName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: HeadingTextColor(context, Color),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Dishes List
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.75, // 80% of screen height
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        _buildDishCard(context, 'Chicken Briyani', 200),
                        SizedBox(height: 20),
                        _buildDishCard(context, 'Grill Chicken', 300),
                        SizedBox(height: 20),
                        _buildDishCard(context, 'Chicken Noodles', 100),
                        SizedBox(height: 20),
                        _buildDishCard(context, 'Chicken Rice', 100),
                        SizedBox(height: 20),
                        _buildDishCard(context, 'Tandoori', 250),
                        SizedBox(height: 20),
                        _buildDishCard(context, 'Pizza', 180),
                        SizedBox(height: 20),
                        _buildDishCard(context, 'Burger', 120),
                        SizedBox(height: 20),

                        // Add more dishes here
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Floating Action Button for Cart
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total price display
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '\₹${cart.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Floating button for cart
            FloatingActionButton.extended(
              backgroundColor: ButtonColor(context, Color),
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                'Go to Cart',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                // Navigate to the OrderPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a styled card for each dish
  Widget _buildDishCard(BuildContext context, String dishName, double price) {
    final cart = context.read<CartProvider>();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: DishCardColor(context, Color),
      //Colors.white.withOpacity(0.8), // Semi-transparent for elegance
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dish image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                foodImages[dishName] ?? '', // Get image from the map
                width: 70, // Adjust the size as needed
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10), // Space between image and text
            // Dish name and price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dishName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HotelNameColor(context, Color),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\₹${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: PriceColor(context, Color),
                      //Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // Add to cart button with increment and decrement
            Row(
              children: [
                // Decrement button
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.black87),
                  onPressed: () {
                    if (cart.items.containsKey(dishName)) {
                      cart.removeItem(dishName);
                    }
                  },
                ),
                // Show quantity
                Text(
                  '${cart.items.containsKey(dishName) ? cart.items[dishName]!['quantity'] : 0}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                // Increment button
                IconButton(
                  icon: Icon(Icons.add, color: Colors.black87),
                  onPressed: () {
                    cart.addItem(dishName, price);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


///----------------------- ORDER PAGE ----------------------------------///

class OrderPage extends StatelessWidget {
  // Map to hold food item images
  final Map<String, String> foodImages = {
    'Chicken Briyani': 'assets/FOODAPPimages/chickenbriyani.jpeg',
    'Grill Chicken': 'assets/FOODAPPimages/grill.jpeg',
    'Chicken Noodles': 'assets/FOODAPPimages/chickennoodles.jpeg',
    'Chicken Rice': 'assets/FOODAPPimages/rice.jpeg',
    'Tandoori': 'assets/FOODAPPimages/tandoori.jpeg',
    'Pizza': 'assets/FOODAPPimages/pizza.jpeg',
    'Burger': 'assets/FOODAPPimages/burger.jpeg',
  };

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: Stack(children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppBackGroundImage(String, context)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Semi-transparent overlay
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        // Main content
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar-like title section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'Your Order',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: HeadingTextColor(context, Color),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Order List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items.keys.elementAt(index);
                    final itemDetails = cart.items[item]!;
                    final quantity = itemDetails['quantity'] as int;
                    final price = itemDetails['price'] as double;

                    return _buildOrderItemCard(context, item, price, quantity);
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
      // Bottom button for proceeding to payment
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the PaymentPage with total price
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(
                  totalPrice: cart.totalPrice,
                ), // Pass the total price
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: ButtonColor(context, Color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ), // Button color
          ),
          child: Text(
            'Proceed to Payment (\₹${cart.totalPrice})',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Helper method to build each order item card
  Widget _buildOrderItemCard(
      BuildContext context, String item, double price, int quantity) {
    final cart = context.read<CartProvider>();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: DishCardColor(context, Color),
      // Semi-transparent for elegance
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Food item image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                foodImages[item] ?? '', // Get image from the map
                width: 70, // Adjust the size as needed
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10), // Space between image and text
            // Food item name and price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HotelNameColor(context, Color),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\₹${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: PriceColor(context, Color),
                    ),
                  ),
                ],
              ),
            ),
            // Quantity and controls
            Row(
              children: [
                // Decrement button
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.black87),
                  onPressed: () {
                    if (quantity > 0) {
                      cart.removeItem(item);
                    }
                  },
                ),
                // Show quantity
                Text(
                  '$quantity',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                // Increment button
                IconButton(
                  icon: Icon(Icons.add, color: Colors.black87),
                  onPressed: () {
                    cart.addItem(item, price);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


///----------------------- PAYMENT PAGE --------------------------///


class PaymentPage extends StatelessWidget {
  final double totalPrice; // Add totalPrice parameter

  // Constructor to accept totalPrice
  PaymentPage({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppBackGroundImage(String, context)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content
          SafeArea(
            child: Center( // Center widget to center content
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Payment Success Icon
                  Icon(
                    Icons.check_circle_outline,
                    size: 100,
                    color: Colors.greenAccent,
                  ),
                  SizedBox(height: 20),

                  // Payment Successful Text
                  Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: HeadingTextColor(context, Color),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Show total price
                  Text(
                    'Total Amount: \₹${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      color: HeadingTextColor(context, Color),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Back to Home Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Clear the cart
                        context.read<CartProvider>().clearCart();

                        // Clear all previous routes and navigate to HomePage
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        backgroundColor: ButtonColor(context, Color),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Back to Home',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///--------------------------- CART PROVIDER --------------------------///


class CartProvider with ChangeNotifier {
  Map<String, Map<String, dynamic>> _items = {};

  Map<String, Map<String, dynamic>> get items => _items;

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  // Calculate total price
  double get totalPrice {
    double total = 0;
    _items.forEach((key, value) {
      total += value['quantity'] * value['price'];
    });
    return total;
  }

  // Add item to cart
  void addItem(String itemName, double price) {
    if (_items.containsKey(itemName)) {
      _items[itemName]!['quantity'] += 1;
    } else {
      _items[itemName] = {'quantity': 1, 'price': price};
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String itemName) {
    if (_items.containsKey(itemName)) {
      if (_items[itemName]!['quantity'] > 1) {
        _items[itemName]!['quantity'] -= 1;
      } else {
        _items.remove(itemName);
      }
    }
    notifyListeners();
  }
}


///-------------------------------------- THEMES --------------------------------------///


String SplashScreenImage(BuildContext, context){
  return "assets/FOODAPPimages/splash.gif";
}

String SignUpLoginBackGroundImage(BuildContext, context){
  return 'assets/FOODAPPimages/signupbackground.jpeg';
}

String AppBackGroundImage(BuildContext, context){
  return 'assets/FOODAPPimages/homepagebackgroud.jpeg';
}

Color ButtonColor(BuildContext, context){
  return Colors.orangeAccent;
}

Color HeadingTextColor(BuildContext, context){
  return Colors.white;
}

Color HotelNameColor(BuildContext, context){
  return Colors.black87;
}

Color PriceColor(BuildContext, context){
  return Colors.black54;
}

Color SignupLoginIconColor(BuildContext, context){
  return Colors.orangeAccent.shade200;
}

Color TextFormFieldBackGroundColor(BuildContext, context){
  return Colors.white.withOpacity(0.3);
}

Color HotelCardColor(BuildContext, context){
  return Colors.white.withOpacity(0.3);
}

Color DishCardColor(BuildContext, context){
  return Colors.white.withOpacity(0.3);
}


///------------------------------------- END ----------------------------------------///