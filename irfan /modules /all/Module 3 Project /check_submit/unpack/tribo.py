def tribonacci(n):
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    else:
        fib_seq = [1, 1, 1]
        for i in range(3, n):
            next_num = fib_seq[i-1] + fib_seq[i-2] + fib_seq[i-3]
            fib_seq.append(next_num)
        return fib_seq

print(tribonacci(20))
