using System.Collections;
using UnityEngine;

public class SimplePlayerController : MonoBehaviour
{
    public float speed = 5.0f;        // Movement speed
    public float jumpForce = 5.0f;    // Jumping force
    private bool isJumping = false;   // Track if player is currently jumping

    private Rigidbody rb;

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    private void Update()
    {
        MovePlayer();

        // Jump when space is pressed and the player is not already jumping
        if (Input.GetKeyDown(KeyCode.Space) && !isJumping)
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
            isJumping = true;
        }
    }

    private void MovePlayer()
    {
        float horizontal = Input.GetAxis("Horizontal");   // A or D / Left Arrow or Right Arrow
        float vertical = Input.GetAxis("Vertical");       // W or S / Up Arrow or Down Arrow

        Vector3 movement = new Vector3(horizontal, 0.0f, vertical) * speed * Time.deltaTime;
        transform.Translate(movement, Space.World);
    }

    // Using OnCollisionEnter to detect if the player is on the ground and can jump again
    private void OnCollisionEnter(Collision collision)
    {
        // Check if the collision is from below (ground)
        if (collision.contacts[0].normal == Vector3.up)
        {
            isJumping = false;
        }
    }
}