# Optimization Techniques

This repository contains MATLAB implementations of algorithms and methods as taught in the Optimization Techniques course at Aristotle University of Thessaloniki.

## Assignment 1: One-Dimensional Optimization
This assignment focuses on minimizing single-variable convex functions within a bounded interval $[a, b]$. It compares derivative-free methods against derivative-based methods regarding function evaluations and convergence speed.

**Methods Implemented:**
- **Dichotomous Search**
- **Golden Section Search**
- **Fibonacci Search**
- **Dichotomous Search with Derivative**

## Assignment 2: Unconstrained Multivariable Optimization
This assignment deals with minimizing multivariable functions (specifically $f: \mathbb{R}^n \to \mathbb{R}$) without constraints. It explores how different descent directions and step-size strategies affect convergence, especially in the presence of saddle points or flat regions.

**Methods Implemented:**
- **Steepest Descent**
- **Newton's Method**
- **Levenberg-Marquardt**

**Step Size Strategies:**
- **Fixed Step**
- **Optimal Step**
- **Armijo Rule**

## Assignment 3: Constrained Multivariable Optimization
This assignment focuses on constrained minimization problems, specifically where the variables are subject to box constraints. It explores how different learning rates affect convergence.

**Methods Implemented:**
- **Projected Steepest Descent**